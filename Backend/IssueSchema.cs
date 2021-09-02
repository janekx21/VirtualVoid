using System;
using GraphQL.Types;

namespace Backend {
    public class IssueSchema : Schema{
        public IssueSchema() {
            Query = new IssueQuery();
            // Mutation = new ChatMutation(chat);
            // Subscription = new ChatSubscriptions(chat);
            RegisterTypeMapping(typeof(MyTypes.User), typeof(UserType));
            RegisterTypeMapping(typeof(MyTypes.Issue), typeof(IssueType));
        }
    }
}
