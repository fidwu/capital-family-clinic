document.addEventListener("DOMContentLoaded", function () {
    // Show the add form when the add button is clicked
    document.querySelector("button.add")?.addEventListener("click", (event) => {
        document.querySelector(".add-form-popup").classList.add("active");
    });

    // Close the add/update form when the close button/x is clicked
    document.querySelector(".add-form-popup button.close")?.addEventListener("click", (event) => {
        document.querySelector(".add-form-popup").classList.remove("active");
        // Update url so that the query parameter (?) from the update form is not part of the URL
        window.location.href = window.location.href.split("?").slice(0, -1).toString();
    });

    document.querySelector(".chart-popup button.close")?.addEventListener("click", (event) => {
        document.querySelector(".chart-popup").classList.remove("active");
        // Update url so that the query parameter (?) from the update form is not part of the URL
        window.location.href = window.location.href.split("?").slice(0, -1).toString();
    });

    // Close the add/update form when the close button/x is clicked
    document.querySelector(".alert button.close")?.addEventListener("click", (event) => {
        console.log("here")
        document.querySelector(".alert").classList.add("hide");
    });

    // Show delete popup when delete button is clicked
    document.querySelectorAll('.delete-trigger').forEach(button => {
        button.addEventListener('click', function(e) {
            // Use data attributes to determine which item to delete
            const dataId = this.getAttribute('data-id');
            document.getElementById('deleteId').value = dataId;
            document.querySelector('.delete-form-popup').classList.add('active');
        });
    });

    // Close delete popup when the cancel button is clicked
    document.getElementById('cancel')?.addEventListener('click', function() {
        document.querySelector('.delete-form-popup').classList.remove('active');
    });

    // Show the reset popup when the reset button on the navigation is clicked
    document.querySelector(".reset-trigger").addEventListener("click", () => {
        document.querySelector('.reset-popup').classList.add('active');
    });

    // Close the reset form when the cancel button is clicked
    document.querySelector('.cancel').addEventListener('click', function() {
        document.querySelector('.reset-popup').classList.remove('active');
    });

    // Toggle filter button
    document.querySelector('.filter-button')?.addEventListener('click', function() {
        document.querySelector('.filters-dropdown-content').classList.toggle('hide');
    });

    // Toggle chart
    document.querySelector('.view-chart')?.addEventListener('click', function() {
        document.querySelector('.chart-popup').classList.toggle('active');
    });

    // Filter results using search for name or select test
    function filterResults() {
        const search = document.getElementById('searchInput').value.toLowerCase();
        const selected = Array.from(document.querySelectorAll('.filter input[type="checkbox"]:checked')).map(filter => filter.name);

        // Determine if page has select filter
        let hasSelectFilter = document.querySelectorAll('.filter input[type="checkbox"]').length;

        document.querySelectorAll('tbody tr').forEach(row => {
            const firstName = row.querySelector('.firstName')?.textContent.toLowerCase();
            const lastName = row.querySelector('.lastName')?.textContent.toLowerCase();
            const name = row.querySelector('.name')?.textContent.toLowerCase();
            const fullName = name != undefined ? name : firstName + ' ' + lastName;
            const test = row.querySelector('.test')?.textContent;

            const matchesText = fullName.includes(search);
            const matchesFilter = selected.includes(test);

            if (matchesText && (hasSelectFilter > 0 ? matchesFilter : true)) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }

    document.getElementById('searchInput')?.addEventListener('input', filterResults);

    // Add event listener for each checkbox
    let checkboxes = document.querySelectorAll('.filter input[type="checkbox"]');
    for (let i = 0; i < checkboxes.length; i++) {
        checkboxes[i].addEventListener('change', filterResults);
    }
});