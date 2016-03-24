// Generated by CoffeeScript 1.4.0
var CompoundNameClassificationView;

CompoundNameClassificationView = CardView.extend({
  initialize: function() {
    this.model.on('change', this.render, this);
    return this.model.on('error', this.showCompoundErrorCard, this);
  },
  render: function() {
    this.renderImage();
    this.renderTitle();
    this.renderPrefName();
    this.renderMaxPhase();
    this.renderMolFormula();
    this.renderSynonymsAndTradeNames();
    $(this.el).children('.card-preolader-to-hide').hide();
    $(this.el).children(':not(.card-preolader-to-hide, .card-load-error)').show();
    this.initEmbedModal('name_and_classification');
    this.renderModalPreview();
    this.initDownloadButtons();
    this.initZoomModal();
    return ChemJQ.autoCompile();
  },
  renderTitle: function() {
    return $(this.el).find('#Bck-CHEMBL_ID').text(this.model.get('molecule_chembl_id'));
  },
  renderPrefName: function() {
    var name, rendered, text;
    name = this.model.get('pref_name');
    text = name !== null ? name : 'Undefined';
    rendered = Handlebars.compile($('#Handlebars-Compound-NameAndClassification-renderPrefName').html())({
      name: text,
      undef: name === null
    });
    return $(this.el).find('#Bck-PREF_NAME').html(rendered);
  },
  renderMaxPhase: function() {
    var description, phase, phase_class, rendered, show_phase, template, tooltip_text;
    phase = this.model.get('max_phase');
    phase_class = 'comp-phase-' + phase;
    show_phase = phase !== 0;
    description = (function() {
      switch (false) {
        case phase !== 1:
          return 'Phase I';
        case phase !== 2:
          return 'Phase II';
        case phase !== 3:
          return 'Phase III';
        case phase !== 4:
          return 'Approved';
        default:
          return 'Undefined';
      }
    })();
    tooltip_text = (function() {
      switch (false) {
        case phase !== 0:
          return 'Phase 0: Exploratory study involving very limited human exposure to the drug, with no ' + 'therapeutic or diagnostic goals (for example, screening studies, microdose studies)';
        case phase !== 1:
          return 'Phase 1: Studies that are usually conducted with healthy volunteers and that emphasize ' + 'safety. The goal is to find out what the drug\'s most frequent and serious adverse events are and, often, ' + 'how the drug is metabolized and excreted.';
        case phase !== 2:
          return 'Phase 2: Studies that gather preliminary data on effectiveness (whether the drug works ' + 'in people who have a certain disease or condition). For example, participants receiving the drug may be ' + 'compared to similar participants receiving a different treatment, usually an inactive substance, called a ' + 'placebo, or a different drug. Safety continues to be evaluated, and short-term adverse events are studied.';
        case phase !== 3:
          return 'Phase 3: Studies that gather more information about safety and effectiveness by studying ' + 'different populations and different dosages and by using the drug in combination with other drugs.';
        case phase !== 4:
          return 'Phase 4: Studies occurring after FDA has approved a drug for marketing. These including ' + 'postmarket requirement and commitment studies that are required of or agreed to by the study sponsor. These ' + 'studies gather additional information about a drug\'s safety, efficacy, or optimal use.';
        default:
          return 'Undefined';
      }
    })();
    template = Handlebars.compile($('#Handlebars-Compound-NameAndClassification-renderMaxPhase').html());
    rendered = template({
      "class": phase_class,
      text: phase,
      desc: description,
      show_phase: show_phase,
      tooltip: tooltip_text
    });
    $(this.el).find('#Bck-MAX_PHASE').html(rendered);
    return $(this.el).find('#Bck-MAX_PHASE').find('.tooltipped').tooltip();
  },
  renderMolFormula: function() {
    if (this.model.get('structure_type') === 'SEQ') {
      return $(this.el).find('#Bck-MOLFORMULA').parent().parent().hide();
    } else {
      return $(this.el).find('#Bck-MOLFORMULA').text(this.model.get('molecule_properties')['full_molformula']);
    }
  },
  renderImage: function() {
    var img, img_url;
    if (this.model.get('structure_type') === 'NONE') {
      img_url = '/static/img/structure_not_available.png';
    } else if (this.model.get('structure_type') === 'SEQ') {
      img_url = '/static/img/protein_structure.png';
    } else {
      img_url = 'https://www.ebi.ac.uk/chembl/api/data/image/' + this.model.get('molecule_chembl_id') + '.svg';
    }
    img = $(this.el).find('#Bck-COMP_IMG');
    img.error(function() {
      return img.attr('src', '/static/img/structure_not_found.png');
    });
    return img.attr('src', img_url);
  },
  renderSynonymsAndTradeNames: function() {
    var all_syns, syn_rendered, synonyms_source, tn_rendered, trade_names, unique_synonyms;
    all_syns = this.model.get('molecule_synonyms');
    unique_synonyms = new Set();
    trade_names = new Set();
    $.each(all_syns, function(index, value) {
      if (value.syn_type === 'TRADE_NAME') {
        return trade_names.add(value.synonyms);
      }
    });
    $.each(all_syns, function(index, value) {
      if (value.syn_type !== 'TRADE_NAME' && !trade_names.has(value.synonyms)) {
        return unique_synonyms.add(value.synonyms);
      }
    });
    if (unique_synonyms.size === 0) {
      $(this.el).find('#CompNameClass-synonyms').parent().parent().parent().hide();
    } else {
      synonyms_source = '{{#each items}}' + ' <span class="CNC-chip-syn">{{ this }}</span> ' + '{{/each}}';
      syn_rendered = Handlebars.compile($('#Handlebars-Compound-NameAndClassification-synonyms').html())({
        items: Array.from(unique_synonyms)
      });
      $(this.el).find('#CompNameClass-synonyms').html(syn_rendered);
    }
    if (trade_names.size === 0) {
      return $(this.el).find('#CompNameClass-tradenames').parent().parent().parent().hide();
    } else {
      tn_rendered = Handlebars.compile($('#Handlebars-Compound-NameAndClassification-tradenames').html())({
        items: Array.from(trade_names)
      });
      return $(this.el).find('#CompNameClass-tradenames').html(tn_rendered);
    }
  },
  initDownloadButtons: function() {
    var img_url;
    img_url = 'https://www.ebi.ac.uk/chembl/api/data/image/' + this.model.get('molecule_chembl_id');
    $('.CNC-download-png').attr('href', img_url + '.png');
    $('.CNC-download-png').attr('download', this.model.get('molecule_chembl_id') + '.png');
    $('.CNC-download-svg').attr('href', img_url + '.svg');
    return $('.CNC-download-svg').attr('download', this.model.get('molecule_chembl_id') + '.svg');
  },
  initZoomModal: function() {
    var img, modal, title;
    modal = $(this.el).find('#CNC-zoom-modal');
    title = modal.find('h3');
    title.text(this.model.get('molecule_chembl_id'));
    img = modal.find('img');
    img.attr('src', $(this.el).find('#Bck-COMP_IMG').attr('src'));
    return img.attr('alt', 'Structure of ' + this.model.get('molecule_chembl_id'));
  }
});
