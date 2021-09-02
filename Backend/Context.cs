using System;
using System.Linq;
using System.Text.Json;
using Microsoft.EntityFrameworkCore;
using static System.IO.Path;

namespace EventSourceDemo {
    public sealed class Context : DbContext {
        // on my pc: C:\Users\janek\AppData\Local
        private const Environment.SpecialFolder folder = Environment.SpecialFolder.LocalApplicationData;
        private readonly string path = Environment.GetFolderPath(folder);

        public Context() {
            Database.Migrate();
        }

        public DbSet<Issue> issues { get; set; } = null!;
        public DbSet<Commit> commits { get; set; } = null!;
        private string dbPath => $"{path}{DirectorySeparatorChar}context.db";

        public void restoreDomain() {
            // remove all
            issues.RemoveRange(issues);
            SaveChanges();

            // restore all
            var issueCommits = commits
                .Where(x => x.className == nameof(Issue))
                .OrderBy(x => x.order).ToList();

            foreach (var commit in issueCommits) {
                if (commit.type == nameof(CommitTypes.Create)) {
                    var create = JsonSerializer.Deserialize<CommitTypes.Create>(commit.payload) ??
                                 throw new InvalidOperationException("could not deserialize Create");
                    var issue = JsonSerializer.Deserialize<Issue>(create.initial) ??
                                throw new InvalidOperationException("could not deserialize Issue");
                    issues.Add(issue);
                }

                if (commit.type == nameof(CommitTypes.Change)) {
                    var (key, value) = JsonSerializer.Deserialize<CommitTypes.Change>(commit.payload) ??
                                       throw new InvalidOperationException("could not deserialize change");
                    var issue = issues.Find(commit.objectId) ?? throw new Exception("issue not found");
                    if (key == nameof(Issue.title)) issue.title = value;
                }
            }

            SaveChanges();
        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder) {
            optionsBuilder.UseSqlite($"Data Source={dbPath}");
        }
    }
}
