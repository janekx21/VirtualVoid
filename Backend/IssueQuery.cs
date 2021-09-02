using System;
using System.Collections.Generic;
using GraphQL.Types;

namespace Backend {
    public sealed class IssueQuery : ObjectGraphType<MyTypes.Query> {
        public IssueQuery() {
            Field(x => x.me).Resolve(_ => new MyTypes.User {
                id = Guid.NewGuid().ToString(),
                name = "Janek with expression"
            });

            Field(x => x.issues).Resolve(_ => new List<MyTypes.Issue> {
                new() {
                    id = Guid.NewGuid().ToString(),
                    title = "Das Problem",
                    description = "Hier kommen viele Probleme zusammen.",
                    children = new List<MyTypes.Issue> {
                        new() {
                            id = Guid.NewGuid().ToString(),
                            title = "Sub Problem",
                            description = "details heir eingeben",
                            children = new List<MyTypes.Issue>()
                        }
                    }
                },
                new() {
                    id = Guid.NewGuid().ToString(),
                    title = "Das Problem2",
                    description = "Hier kommen viele Probleme zusammen.",
                    children = new List<MyTypes.Issue>()
                },
                new() {
                    id = Guid.NewGuid().ToString(),
                    title = "Das Problem3",
                    description = "Hier kommen viele Probleme zusammen.",
                    children = new List<MyTypes.Issue>()
                },
            });
        }
    }
}
