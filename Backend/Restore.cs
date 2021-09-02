using System;
using System.Collections.Generic;
using System.Text.Json;
using EventSourceDemo;

namespace VirtualVoid {
    public class Restore {
        public delegate void CreateFunc(Context context, CommitTypes.Create commit);

        public readonly Dictionary<string, CreateFunc> allCreate = new() {
            {
                nameof(Issue), (context, commit) => {
                    var issue = JsonSerializer.Deserialize<Issue>(commit.initial) ??
                                throw new InvalidOperationException("could not deserialize Issue");
                    context.issues.Add(issue);
                }
            }
        };

        public delegate void UpdateFunc(Context context, CommitTypes.Change commit, Guid objectId);

        public readonly Dictionary<string, UpdateFunc> allUpdate = new() {
            {
                nameof(Issue), (context, commit, objectId) => {
                    var issue = context.issues.Find(objectId) ?? throw new Exception("issue not found");
                    if (commit.key == nameof(Issue.title)) issue.title = commit.value;
                }
            }
        };
    }
}
