/*
<License>
</License>
*/
package ch.unizh.unipublic.lenya.cms.publication;

import java.util.ArrayList;
import java.util.List;

import org.apache.lenya.cms.publication.Document;
import org.apache.lenya.cms.publication.DocumentBuilder;
import org.apache.lenya.cms.publication.DublinCore;
import org.apache.lenya.cms.publication.Publication;
import org.apache.lenya.cms.publication.PublicationException;
import org.apache.lenya.cms.publication.ResourceFactory;
import org.apache.lenya.cms.publication.ResourceIdentityMap;
import org.apache.lenya.cms.publication.Version;
import org.apache.lenya.cms.publication.XlinkCollection;
import org.apache.lenya.cms.publication.impl.ResourceFactoryImpl;
import org.apache.lenya.cms.publication.impl.ResourceImpl;
import org.apache.lenya.cms.publication.util.AreaFilter;
import org.apache.lenya.cms.publication.util.ComposedFilter;
import org.apache.lenya.cms.publication.util.LanguageFilter;
import org.apache.log4j.Category;


/**
 * An article.
 * 
 * @author <a href="edith@apache.org">Edith Chevrier</a>
 * 
 */
public class Article extends ResourceImpl {
    
    private static final Category log = Category.getInstance(Article.class);    

    /**
     * Ctor.
     * @param resourceId The resource ID.
     * @param identityMap The identity map that stores this resource.
     */
    public Article(ResourceIdentityMap identityMap, String resourceId) {
        super(identityMap, resourceId);
    }

    /**
     * Checks if a document ID represents an article.
     * @param documentId The document ID.
     * @return A boolean value.
     */
    public static boolean isArticleDocument(String documentId){
        documentId = documentId.substring(1);
        String[] steps = documentId.split("/");
        if (steps.length == 4 ) {
            return true;
        }
        return false;
      }

    public boolean isAlreadyPublished() throws PublicationException {
        List versions = getVersions();
        if (versions.size() > 0) {
        	ArticleVersion article = (ArticleVersion) versions.get(0);
        	String publishedDate = article.getDocument().getDublinCore().getValues(DublinCore.TERM_ISSUED)[0];
        	if (publishedDate != null && !publishedDate.equals("")) {
              return true;
        	}
        }
        return false;
    }

}
