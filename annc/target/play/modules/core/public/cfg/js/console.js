$(function () {
    if ($('table.list-table').size()) {
        $('table.list-table tr:odd').addClass('odd');
        $('table.list-table tr:even').addClass('even');
        $("table.list-table tr").hover(
            function () {
                $(this).addClass("hover");
            },
            function () {
                $(this).removeClass("hover");
            }
        )
    }
    $('form').validationEngine();
});

function getIndexCount(aid, cid, a) {
    $.post('totalCount.do', {aid:aid, cid:cid}, function (html) {
        $(a).next().html(html);
    });
    return false;
}

function changeSelect(box) {
    $("[type='checkbox']", $(box).parent().parent().parent()).each(function () {
        if ($(box).attr("checked")) {
            $(this).attr("checked", 'true');
        } else {
            $(this).removeAttr("checked");
        }
    });
}

function removeSelected(input) {
    $("td input[type='checkbox']", $(input).parent().parent()).each(function () {
        if ($(this).attr("checked")) {
            $(this).parent().parent().remove();
        }
    });
    return false;
}

function addRow(input, ct) {
    $(input).parent().next().append($(ct).val());
    return false;
}

function moveRow(el, isUp) {
    var tr = $(el).parent().parent();
    if (isUp) {
        var prevTr = tr.prev();
        if (prevTr[0] && !prevTr.find("th")[0]) {
            tr.insertBefore(prevTr);
        }
    } else {
        var nextTr = tr.next();
        if (nextTr[0]) {
            tr.insertAfter(nextTr);
        }
    }
    return false;
}