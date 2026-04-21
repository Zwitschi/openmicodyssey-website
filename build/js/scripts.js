(function () {
  var nav = document.getElementById("nav-links");
  var toggle = document.querySelector(".nav-toggle");

  if (toggle && nav) {
    toggle.addEventListener("click", function () {
      var isOpen = nav.classList.toggle("is-open");
      toggle.setAttribute("aria-expanded", String(isOpen));
    });
  }

  var page = document.body.getAttribute("data-page");
  var links = document.querySelectorAll(".nav-links a");

  links.forEach(function (link) {
    var href = link.getAttribute("href") || "";
    if (
      (page === "overview" && href === "index.html") ||
      (page === "film" && href === "film.html") ||
      (page === "gallery" && href === "gallery.html") ||
      (page === "support" && href === "support.html") ||
      (page === "film" && href === "#tickets")
    ) {
      link.classList.add("is-active");
    }
  });

  document.querySelectorAll("[data-current-year]").forEach(function (node) {
    node.textContent = String(new Date().getFullYear());
  });
})();
