using GraphQL.Types;

namespace Backend {
    public sealed class UserType : ObjectGraphType<MyTypes.User> {
        public UserType() {
            Field(o => o.id);
            Field(o => o.name);
        }
    }
}
