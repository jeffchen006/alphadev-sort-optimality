# n=5 model=out iset=I1 prefix14_class=6011
cmp P3, P0
mov S1, P0
mov S2, P2
cmovl S1, P3
cmovle P3, P0
cmp P1, P2
cmovle P2, P1
cmovle P1, S2
cmp P3, P1
mov S0, P3
cmovge P3, P1
cmovle S0, P1
cmp P2, S1
mov P1, P3
