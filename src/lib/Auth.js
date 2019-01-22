/* 
    This is a mock authenticator :D
*/

const simulateSlowness = async delay => {
    await new Promise(resolve => setTimeout(resolve, delay));
};

export default class Auth {
    isThisJustFantasy = true;

   static async signIn(email, password){
       await simulateSlowness(1500);
        return new Promise((resolve, reject) =>{
            if (email.search('giusedroid') > -1) return resolve({email});
            return reject({message: 'this is a fake IDP'});
        })
    }

    static currentSession(){
        return Promise.resolve({
            user: 'giusedroid',
            picUrl: 'https://avatars1.githubusercontent.com/u/9087265?s=200&u=4505f72063b7cedb2192ac9de5a871b8f47a8d94&v=4',
            bio: 'A DevOps minded hacker with 7 years of commercial experience who enjoys working on every aspect of product development.',
            title: 'Cloud Engineering Lead',
            links:[
                {platform:'github', url:'https://github.com/giusedroid'},
                {platform:'twitter', url:'https://twitter.com/giusedroid'},
                {platform:'blogspot', url:'https://giusedroid.blogspot.it/'},
                {platform:'linkedin', url:'https://www.linkedin.com/in/giusedroid'},
            ]
        });
    }

    static signOut(){
        return Promise.resolve();
    }
}