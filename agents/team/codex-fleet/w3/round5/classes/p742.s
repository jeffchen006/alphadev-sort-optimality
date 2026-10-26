# n=5 model=out iset=I1 prefix14_class=742
cmp P2, P0
cmovle S2, P2
cmovge S2, P0
cmovle P2, P0
cmp P3, P1
mov P0, P3
cmovg P0, P1
cmovl P3, P1
mov S0, P3
cmp P3, P2
cmovle P3, P2
cmovle P2, S0
mov S0, P0
mov P3, P2
