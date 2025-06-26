<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Contracts\HttpClient\HttpClientInterface;

class ExoplanetController extends AbstractController
{
    private HttpClientInterface $client;

    public function __construct(HttpClientInterface $client)
    {
        $this->client = $client;
    }

    #[Route('/api/exoplanets', name: 'api_exoplanets')]
    public function fetch(): JsonResponse
    {
        // ✅ Requête enrichie
        // $query = "select top 500 pl_name, pl_rade, pl_bmassj, st_spectype, discoverymethod, disc_year, st_dist, pl_dens, pl_eqt, pl_orbper, st_teff, st_rad from ps where pl_rade is not null";


        // $encodedQuery = urlencode($query);
        // $url = "https://exoplanetarchive.ipac.caltech.edu/TAP/sync?query={$encodedQuery}&format=csv";
        $query = <<<EOD
    SELECT top 500 pl_name, MAX(pl_rade) AS pl_rade, MAX(disc_year) AS disc_year
    FROM ps
    WHERE pl_rade IS NOT NULL
    GROUP BY pl_name
EOD;

$encodedQuery = urlencode($query);
$url = "https://exoplanetarchive.ipac.caltech.edu/TAP/sync?query={$encodedQuery}&format=csv";



        try {
            $response = $this->client->request('GET', $url);
            $csv = $response->getContent();

            // Convertir CSV → tableau
            $lines = explode("\n", $csv);
            $headers = str_getcsv(array_shift($lines));
            $data = [];

            foreach ($lines as $line) {
                if (trim($line) === '') continue;
                $row = str_getcsv($line);
                $data[] = array_combine($headers, $row);
            }

            return $this->json($data);
        } catch (\Exception $e) {
            return $this->json([
                'error' => 'NASA API Error: ' . $e->getMessage()
            ], Response::HTTP_BAD_REQUEST);
        }
    }
}
