# n=5 model=out iset=I1 prefix14_class=2977
mov S1, P3
cmp P3, P1
mov S0, P2
cmovle S1, P1
cmovl P1, P3
cmp S0, P0
cmovg S0, P0
cmovge P0, P2
cmp P0, S1
mov S2, S1
cmovle S1, P0
cmovle P0, S2
cmp P1, S0
cmovg P3, S0
