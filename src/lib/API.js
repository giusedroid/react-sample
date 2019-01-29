const endpoints = {
  notes: [
    {
      noteId: 0,
      content: 'A Sample Note\nHere is a second line',
      createdAt: 1548152070949,
      attachment: true,
    },

    {
      noteId: 1,
      content: 'This is just a mock\nHere is a second line',
      createdAt: 1548152070999,
    },

    {
      noteId: 2,
      content: 'You realize it, right?\nHere is a second line',
      createdAt: 1548152072534,
      attachment: true,
    },

  ],
};

export default class API {
  static post(name, path, options) {
    return Promise.resolve({
      name,
      path,
      options,
    });
  }

  static get(name) {
    return endpoints[name];
  }

  static getItem(id) {
    return endpoints
      .notes.filter(note => note.noteId === parseInt(id, 10))[0] || endpoints.notes[0];
  }

  static getAttachment() {
    return 'https://ichef.bbci.co.uk/images/ic/720x405/p0517py6.jpg';
  }
}
