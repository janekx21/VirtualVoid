using System;
using GraphQL;
using VirtualVoid.Model;

namespace VirtualVoid {
    public static class ResolveExtenstion {
        public static Guid getId(this IResolveFieldContext<Types.Mutation> c) {
            return Guid.Parse(c.GetArgument<string>("id"));
        }
    }
}
