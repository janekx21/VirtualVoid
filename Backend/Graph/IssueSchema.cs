using System;
using EventSourceDemo;
using GraphQL.Types;
using VirtualVoid.Model;

namespace VirtualVoid {
    public class IssueSchema : Schema{
        public IssueSchema(Context context) {
            Query = new IssueQuery();
            // Mutation = new ChatMutation(chat);
            // Subscription = new ChatSubscriptions(chat);
            RegisterTypeMapping(typeof(Types.User), typeof(UserType));
            RegisterTypeMapping(typeof(Types.Issue), typeof(IssueType));
        }
    }
}
