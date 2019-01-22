import Auth from "./Auth";

it("Authenticates users from cloudreach!", async () => {
    await expect(Auth.signIn('cloudreach', 'whatever')).resolves.toEqual({email:'cloudreach'});
});

it("Won't authenticate anybody else", async () => {
    await expect(Auth.signIn('nope', 'whatever')).rejects;
});

it("Will return the same session, as this is a mock implementation of an IDP", async () => {
    const user = await Auth.currentSession();
    expect(user).toHaveProperty('user');
    expect(user).toHaveProperty('title');
    // so on and so forth
});