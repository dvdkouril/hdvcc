<script lang="ts">
	export let where;
	export let when;
	export let pr;
	export let youtubeLinkID;
	export let description;
	export let image;
	export let imageAltText;
</script>

<p>
	<b>{when}. {where}.</b><br />
	<i
		>Video: <a href="https://youtu.be/{youtubeLinkID}"
			>youtube.com/watch?v={youtubeLinkID}</a
		></i
	><br />
	<i
		>Code: <a href="https://github.com/dvdkouril/hdvcc/pull/{pr}"
			>github.com/dvdkouril/hdvcc/pull/{pr}</a
		></i
	><br />
	{description}
	{#if image !== undefined}
		<img class="thumb" width="600" src={image} alt={imageAltText} />
	{/if}
</p>

<style>
	p {
		font-size: 1.2em;
		margin-left: 20px;
	}

	.thumb {
		margin-top: 15px;
	}
</style>
