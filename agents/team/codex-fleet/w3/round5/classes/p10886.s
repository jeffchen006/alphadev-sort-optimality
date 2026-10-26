# n=5 model=out iset=I1 prefix14_class=10886
cmp P2, P1
cmovg S2, P1
cmovge P1, P2
cmovle S2, P2
cmp P3, P0
cmovg S0, P0
cmovg P0, P3
cmovg P3, S0
mov P2, P0
cmp P2, P1
cmovle P0, P1
cmovl P1, P2
cmp S2, P3
cmovle P2, P3
