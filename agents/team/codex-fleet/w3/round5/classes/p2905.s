# n=5 model=out iset=I1 prefix14_class=2905
mov S1, P1
cmp S1, P0
cmovg S1, P0
cmovl P1, P0
mov P0, P3
cmp P2, P0
cmovg P0, P2
cmovge P2, P3
cmp P0, P1
cmovle S2, P0
cmovle P0, P1
mov P0, P2
cmovle P1, S2
cmp P2, S1
