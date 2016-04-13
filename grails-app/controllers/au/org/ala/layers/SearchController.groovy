/*
 * Copyright (C) 2016 Atlas of Living Australia
 * All Rights Reserved.
 *
 * The contents of this file are subject to the Mozilla Public
 * License Version 1.1 (the "License"); you may not use this file
 * except in compliance with the License. You may obtain a copy of
 * the License at http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS
 * IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
 * implied. See the License for the specific language governing
 * rights and limitations under the License.
 */

package au.org.ala.layers

class SearchController {

    def searchDao

    /*
     * perform a search operation
     */

    def search() {
        def q = params.get('q', null)
        def limit = params.int('limit', 20)

        if (q == null) {
            render status: 404, text: 'No search parameter q.'
        }
        try {
            q = URLDecoder.decode(q, "UTF-8");
            q = q.trim().toLowerCase();
        } catch (UnsupportedEncodingException ex) {
            render status: 404, text: 'Failed to parse search parameter q'
        }

        return searchDao.findByCriteria(q, limit);
    }
}