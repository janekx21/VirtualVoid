using System;
using EventSourceDemo;
using GraphQL.Types;
using VirtualVoid.Model;

namespace VirtualVoid {
    public class IssueSchema : Schema {
        public IssueSchema(Context context, IServiceProvider provider) : base(provider) {
            Query = new QueryType(context);
            Mutation = new MutationType(context);
            Subscription = new SubscriptionType();

            RegisterTypeMapping(typeof(Types.User), typeof(UserType));
            RegisterTypeMapping(typeof(Types.Issue), typeof(IssueType));
            RegisterTypeMapping(typeof(Types.Board), typeof(BoardType));
            RegisterTypeMapping(typeof(Types.State), typeof(StateType));
            RegisterTypeMapping(typeof(Types.BoardInput), typeof(BoardInput));
        }
    }
}
