<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;
use App\Models\Invoice;

class InvoiceFactory extends Factory
{
    /**
     * The name of the factory's corresponding model.
     *
     * @var string
     */
    protected $model = Invoice::class;

    /**
     * Define the model's default state.
     */
    public function definition(): array
    {
        return [
            'issue_date' => $this->faker->dateTime(),
            'user' => $this->faker->word,
            'total' => $this->faker->numberBetween(-10000, 10000),
            'client' => $this->faker->word,
            'deadline' => $this->faker->date(),
            'client_id_card' => $this->faker->word,
            'authorization_code' => $this->faker->word,
            'control_code' => $this->faker->word,
        ];
    }
}
