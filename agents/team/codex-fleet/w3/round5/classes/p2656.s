# n=5 model=out iset=I1 prefix14_class=2656
mov S0, P2
mov S2, P1
cmp P0, S0
cmovg S0, P0
cmovle P2, P0
cmp P1, P3
cmovle P1, P3
cmovge S2, P3
cmp S0, P1
mov P3, S2
cmovle S1, P1
cmovl P1, S0
cmovle S0, S1
cmp P2, S2
