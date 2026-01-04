
function switchSection(id, element) {
    document.querySelectorAll('.flower-item').forEach(item => item.classList.remove('active'));
    element.classList.add('active');
    document.querySelectorAll('.section-block').forEach(block => block.classList.remove('active'));
    document.getElementById(id).classList.add('active');
}