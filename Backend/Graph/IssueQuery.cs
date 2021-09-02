using System;
using System.Collections.Generic;
using GraphQL.Types;
using VirtualVoid.Model;

namespace VirtualVoid {
    public sealed class IssueQuery : ObjectGraphType<Types.Query> {
        public IssueQuery() {
            Field(x => x.me).Resolve(_ => new Types.User {
                id = Guid.NewGuid().ToString(),
                name = "Janek with expression"
            });

            Field(x => x.issues).Resolve(_ => new List<Types.Issue> {
                new() {
                    id = Guid.NewGuid().ToString(),
                    title = "Das Problem",
                    description = "Hier kommen viele Probleme zusammen.",
                    children = new List<Types.Issue> {
                        new() {
                            id = Guid.NewGuid().ToString(),
                            title = "Sub Problem",
                            description = "details heir eingeben",
                            children = new List<Types.Issue>()
                        }
                    }
                },
                new() {
                    id = Guid.NewGuid().ToString(),
                    title = "Das Problem2",
                    description = "Hier kommen viele Probleme zusammen.",
                    children = new List<Types.Issue>()
                },
                new() {
                    id = Guid.NewGuid().ToString(),
                    title = "Das Problem3",
                    description = "Hier kommen viele Probleme zusammen.",
                    children = new List<Types.Issue>()
                },
            });
        }
    }
}
