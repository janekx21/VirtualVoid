using System;
using System.Linq;
using EventSourceDemo;
using GraphQL;
using GraphQL.Types;
using VirtualVoid.Model;

namespace VirtualVoid {
    public class MutationType : ObjectGraphType<Types.Mutation> {
        public MutationType(Context context) {
            Field(o => o.createBoard).Resolve(c => {
                var e = context.boards.Add(new Board {
                    id = Guid.NewGuid(),
                    name = c.GetArgument<string>("name").ToString(),
                    issues = Enumerable.Empty<Issue>(),
                    states = Enumerable.Empty<State>()
                });
                context.SaveChangesAsync();
                return e.Entity.toModel();
            }).Argument<StringGraphType>("name");

            Field(o => o.updateBoard).Resolve(c => {
                var e = context.boards.Find(c.getId());
                e.name = c.GetArgument<Types.BoardInput>("board").name;
                context.SaveChangesAsync();
                return e.toModel();
            }).Argument<StringGraphType>("id").Argument<BoardInput>("board");

            Field(o => o.deleteBoard).Resolve(c => {
                var e = context.boards.Find(c.getId());
                context.boards.Remove(e);
                context.SaveChangesAsync();
                return null;
            });
        }
    }
}
