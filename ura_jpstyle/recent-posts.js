document.addEventListener('DOMContentLoaded', function() {
    fetch('posts/')
        .then(response => response.text())
        .then(data => {
            const parser = new DOMParser();
            const htmlDocument = parser.parseFromString(data, 'text/html');
            const postLinks = htmlDocument.querySelectorAll('a');
            const postPattern = /^\d{4}-\d{2}-\d{2}-[^/]+\.html$/;

            let posts = [];

            for (let link of postLinks) {
                if (postPattern.test(link.textContent)) {
                    posts.push({
                        date: link.textContent.substr(0, 10),
                        name: link.textContent.substr(11),
                        url: 'posts/' + link.textContent
                    });
                }
            }

            posts.sort((a, b) => b.date.localeCompare(a.date)).slice(0, 6);

            const recentPostsContainer = document.getElementById('recent-posts');
            for (let post of posts) {
                const postLink = document.createElement('a');
                postLink.href = post.url;
                postLink.textContent = post.name;
                recentPostsContainer.appendChild(postLink);
                recentPostsContainer.appendChild(document.createElement('br'));
            }
        });
});