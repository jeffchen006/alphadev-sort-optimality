# n=5 model=out iset=I1 prefix14_class=744
cmp P2, P0
cmovle S2, P2
cmovge S2, P0
cmovle P2, P0
cmp P1, P3
mov P0, P1
cmovg P0, P3
cmovl P1, P3
mov S0, P1
cmp P1, P2
cmovle P1, P2
cmovle P2, S0
mov S0, S2
mov P1, P2
