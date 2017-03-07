// Button Variables
var influence_all = true; 
var influence_local = false; 
var influence_national = false;
var influence_future = false; 
var influence_none = false;

function all_kol()
{
	influence_all = true;
	influence_none = false;
	influence_national = false;
	influence_future = false;
	influence_local = false;
	main_function_reader();
	chloropeth_index();
}

function national_kol()
{
	influence_all = false;
	influence_none = false;
	influence_national = true;
	influence_future = false;
	influence_local = false;
	main_function_reader();
	chloropeth_index();
}

function future_kol()
{
	influence_all = false;
	influence_none = false;
	influence_national = false;
	influence_future = true;
	influence_local = false;
	main_function_reader();
	chloropeth_index();
}

function local_kol()
{
	influence_all = false;
	influence_none = false;
	influence_national = false;
	influence_future = false;
	influence_local = true;
	main_function_reader();
	chloropeth_index();
}

function none_kol()
{
	influence_all = false;
	influence_none = true;
	influence_national = false;
	influence_future = false;
	influence_local = false;
	main_function_reader();
	chloropeth_index();
}
