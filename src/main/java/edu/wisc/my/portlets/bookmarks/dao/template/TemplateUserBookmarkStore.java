/* Copyright 2006 The JA-SIG Collaborative.  All rights reserved.
*  See license distributed with this file and
*  available online at http://www.uportal.org/license.html
*/

package edu.wisc.my.portlets.bookmarks.dao.template;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import edu.wisc.my.portlets.bookmarks.dao.BookmarkStore;
import edu.wisc.my.portlets.bookmarks.domain.BookmarkSet;
import edu.wisc.my.portlets.bookmarks.domain.Entry;
import edu.wisc.my.portlets.bookmarks.domain.support.FolderUtils;

/**
 * Creates new BookmarkSet objects based on bookmarks for a template user,
 * passes all other operations to an enclosed BookmarkStore instance.
 *
 * @author Drew Wills <a href="mailto:drew@unicon.net">drew@unicon.net</a>
 * @version $Revision: 12173 $
 */
public class TemplateUserBookmarkStore implements BookmarkStore {

	// Instance Members.
    private final Log logger = LogFactory.getLog(this.getClass());
	private final BookmarkStore enclosed;
	private final TemplateBookmarkSetResolver resolver;

	/*
	 * Public API.
	 */

	public TemplateUserBookmarkStore(BookmarkStore enclosed, TemplateBookmarkSetResolver resolver) {

		// Assertions.
		if (enclosed == null) {
			String msg = "Argument 'enclosed' cannot be null.";
			throw new IllegalArgumentException(msg);
		}
		if (resolver == null) {
			String msg = "Argument 'resolver' cannot be null.";
			throw new IllegalArgumentException(msg);
		}

		// Instance Members.
		this.enclosed = enclosed;
		this.resolver = resolver;

	}

    /**
     * @see edu.wisc.my.portlets.bookmarks.dao.BookmarkStore#getBookmarkSet(java.lang.String, java.lang.String)
     */
    public BookmarkSet getBookmarkSet(String owner, String name) {

    	BookmarkSet rslt = enclosed.getBookmarkSet(owner, name);
    	BookmarkSet template = resolver.getTemplateBookmarkSet(owner, name, enclosed);
    	if (rslt == null && template != null && template.getChildren().size() > 0) {
    		// Give the user a set of bookmarks if...
    		//  1. they don't already have one; and
    		//  2. there's something to give them
    		rslt = this.createBookmarkSet(owner, name);
    	}

        return rslt;

    }

    /**
     * @see edu.wisc.my.portlets.bookmarks.dao.BookmarkStore#storeBookmarkSet(edu.wisc.my.portlets.bookmarks.domain.BookmarkSet)
     */
    public void storeBookmarkSet(BookmarkSet bookmarkSet) {
    	enclosed.storeBookmarkSet(bookmarkSet);
    }

    /**
     * @see edu.wisc.my.portlets.bookmarks.dao.BookmarkStore#removeBookmarkSet(java.lang.String, java.lang.String)
     */
    public void removeBookmarkSet(String owner, String name) {
    	enclosed.removeBookmarkSet(owner, name);
    }


    /**
     * @see edu.wisc.my.portlets.bookmarks.dao.BookmarkStore#createBookmarkSet(java.lang.String, java.lang.String)
     */
    public BookmarkSet createBookmarkSet(String owner, String name) {

    	BookmarkSet rslt = enclosed.createBookmarkSet(owner, name);

    	BookmarkSet template = resolver.getTemplateBookmarkSet(owner, name, enclosed);
    	if (template != null && template.getChildren().size() > 0) {
    		for (Entry y : template.getChildren().values()) {
    			Entry newEntry = FolderUtils.deepClone(y, false);
    			rslt.getChildren().put((long) newEntry.hashCode(), newEntry);
    		}
    		logger.info("TemplateUserBookmarkStore created a new BookmarkSet for user '"
    				+ owner + "' with " + rslt.getChildren().size() + " bookmarks.");
    	}
    	enclosed.storeBookmarkSet(rslt);

        return rslt;

    }

}