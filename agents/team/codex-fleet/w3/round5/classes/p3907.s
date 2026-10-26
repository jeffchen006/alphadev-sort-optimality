# n=5 model=out iset=I1 prefix14_class=3907
mov S0, P1
cmp P1, P2
cmovge P1, P2
cmovg P2, S0
cmp P3, P0
mov S0, P3
cmovl P3, P0
cmovle P0, S0
cmp P1, P0
cmovge S2, P1
cmovle S2, P0
cmovl P0, P1
mov P0, S2
cmp P3, P2
