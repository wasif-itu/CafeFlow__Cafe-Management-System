(() => {
      const sidebar = document.getElementById('sidebar');
      const toggleBtn = document.getElementById('nav-toggle');
      const collapseBtn = document.getElementById('collapse-btn');
      const body = document.body;
      const mq = window.matchMedia("(max-width: 720px)");

      function setAria(expanded) {
        toggleBtn.setAttribute('aria-expanded', expanded ? 'true' : 'false');
      }

      function toggleNav() {
        if (mq.matches) {
          sidebar.classList.toggle('expanded');
          body.classList.toggle('nav-open');
          setAria(sidebar.classList.contains('expanded'));
        } else {
          sidebar.classList.toggle('collapsed');
          setAria(!sidebar.classList.contains('collapsed'));
        }
        updateCollapseBtnVisibility();
      }

      function updateCollapseBtnVisibility() {
        if(sidebar.classList.contains('collapsed')) {
          collapseBtn.style.display = 'none';
        } else {
          collapseBtn.style.display = 'inline';
        }
      }

      toggleBtn.addEventListener('click', toggleNav);
      collapseBtn.addEventListener('click', () => {
        sidebar.classList.add('collapsed');
        setAria(false);
        updateCollapseBtnVisibility();
      });

      setAria(false);
      updateCollapseBtnVisibility();

      document.addEventListener('click', e => {
        if (mq.matches && !sidebar.contains(e.target) && !toggleBtn.contains(e.target) && sidebar.classList.contains('expanded')) {
          sidebar.classList.remove('expanded');
          body.classList.remove('nav-open');
          setAria(false);
          updateCollapseBtnVisibility();
        }
      });
    })();
    
window.addEventListener('DOMContentLoaded', () => {
    if (window.location.pathname.includes("index.html")) {
        console.log("Welcome!");
    }

    const navLinks = document.querySelectorAll("nav a");
    navLinks.forEach(link => {
        if (link.href === window.location.href) {
            link.style.backgroundColor = "#a1887f";
            link.style.color = "white";
        }
    });

    const passwordInput = document.querySelector('input[type="password"]');
    if (passwordInput) {
        const toggle = document.createElement('button');
        toggle.textContent = 'Show';
        toggle.type = 'button';
        toggle.style.marginLeft = '10px';
        toggle.onclick = () => {
            passwordInput.type = passwordInput.type === 'password' ? 'text' : 'password';
            toggle.textContent = passwordInput.type === 'password' ? 'Show' : 'Hide';
        };
        passwordInput.parentNode.appendChild(toggle);
    }
});
