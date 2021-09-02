using System;
using System.Collections.Generic;
using System.Linq;
using EventSourceDemo;
using GraphQL.Types;
using VirtualVoid.Model;

namespace VirtualVoid {
    public sealed class QueryType : ObjectGraphType<Types.Query> {
        public QueryType(Context context) {
            Field(x => x.me, true).Resolve(_ => new Types.User {
                id = Guid.NewGuid().ToString(),
                userName = "Janek with expression"
            });

            Field(x => x.boards, true).Resolve(_ => context.boards.Select(board => new Types.Board {
                id = board.id.ToString(),
                name = board.name,
                issues = board.issues.Select(issue => new Types.Issue {
                    id = issue.id.ToString(),
                    title = issue.title,
                    description = issue.description,
                    state = new Types.State{id = issue.state.id.ToString(), name = issue.state.name}
                }).ToList(),
                states = board.states.Select(state => new Types.State {
                    id = state.id.ToString(),
                    name = state.name
                }).ToList()
            }).ToList());
        }
    }
}
