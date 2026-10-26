# n=5 model=out iset=I1 prefix14_class=1972
cmp P1, P2
cmovle S0, P1
cmovge S0, P2
mov S2, P0
cmovle P1, P2
cmp P3, S2
cmovle P0, P3
cmovg S2, P3
mov P3, P1
cmp P1, S2
cmovle P1, S2
cmovl S2, P3
cmp P0, S0
cmovle P2, P0
