# n=5 model=out iset=I1 prefix14_class=7793
mov S2, P0
cmp S2, P3
cmovle S2, P3
cmovl P3, P0
mov S0, P1
cmp P1, P2
cmovle P1, P2
cmovge S0, P2
cmp S0, P3
cmovle S1, P3
cmovle P3, S0
cmovge S1, S0
mov P3, P1
mov S0, S1
