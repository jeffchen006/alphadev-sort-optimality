# n=5 model=out iset=I1 prefix14_class=13692
mov S1, P0
cmp S1, P2
cmovge P0, P2
mov S2, P1
cmovle S1, P2
cmp S2, P3
cmovle P1, P3
cmovg S2, P3
cmp S2, P0
cmovge P3, S2
cmovg S2, P0
cmovg P0, P3
mov S2, P1
mov P2, P0
