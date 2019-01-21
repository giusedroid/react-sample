/* 
    This is a mock authenticator :D
*/

export default class Auth {
   static signIn(email, password){
        return new Promise((resolve, reject) =>{
            if (email.search('giusedroid') > -1) return resolve({email});
            return reject({message: 'this is a fake IDP'});
        })
    }
}