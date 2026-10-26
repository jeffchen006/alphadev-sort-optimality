# n=5 model=out iset=I1 prefix14_class=12888
cmp P1, P2
cmovle S0, P1
cmovge S0, P2
cmovl P1, P2
cmp P3, P0
cmovle P2, P0
cmovl P0, P3
cmovle P3, P2
cmp P0, S0
mov S2, P0
mov S1, P1
cmovge S2, S0
cmovle P0, S0
mov S0, P0
