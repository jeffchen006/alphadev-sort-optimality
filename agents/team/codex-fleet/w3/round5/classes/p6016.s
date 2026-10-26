# n=5 model=out iset=I1 prefix14_class=6016
mov S2, P1
cmp P2, P0
mov S0, P0
cmovl P0, P2
cmovle P2, S0
cmp P3, S2
cmovle S2, P3
cmovle P3, P1
mov S1, P2
cmp S1, P3
cmovge P2, P3
cmovg P3, S1
cmp P0, S2
cmovg S1, S2
