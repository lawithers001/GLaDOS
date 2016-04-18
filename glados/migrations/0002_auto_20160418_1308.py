# -*- coding: utf-8 -*-
# Generated by Django 1.9.2 on 2016-04-18 13:08
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('glados', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='acknowledgement',
            name='category',
            field=models.CharField(choices=[('Funding', 'Funding')], default='Funding', max_length=20),
        ),
        migrations.AlterField(
            model_name='acknowledgement',
            name='is_current',
            field=models.IntegerField(blank=True, null=True),
        ),
    ]
