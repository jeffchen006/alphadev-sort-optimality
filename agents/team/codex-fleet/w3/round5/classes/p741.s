# n=5 model=out iset=I1 prefix14_class=741
cmp P2, P0
cmovle S2, P2
cmovle P2, P0
cmovge S2, P0
cmp P1, P3
mov P0, P1
cmovg P0, P3
cmovl P1, P3
cmp P1, P2
mov S0, P1
cmovle P1, P2
cmovl P2, S0
mov P1, P2
mov S0, P0
