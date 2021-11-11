# Generated by Django 3.2.9 on 2021-11-11 14:06

import contrib.timescale.fields
import django.contrib.gis.db.models.fields
from django.db import migrations, models
import django.utils.timezone


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Event',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('data', models.JSONField(null=True)),
                ('location', django.contrib.gis.db.models.fields.PointField(srid=4326)),
                ('created_at', contrib.timescale.fields.TimescaleDateTimeField(default=django.utils.timezone.now, interval='1 day')),
            ],
        ),
    ]
