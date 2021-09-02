using GraphQL.Types;
using VirtualVoid.Model;

namespace VirtualVoid {
    public sealed class UserType : ObjectGraphType<Types.User> {
        public UserType() {
            Field(o => o.id);
            Field(o => o.userName);
            Field(o => o.firstName);
            Field(o => o.lastName);
        }
    }
}
