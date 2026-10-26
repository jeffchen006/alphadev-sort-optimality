# n=5 model=out iset=I1 prefix14_class=6675
mov S1, P1
cmp P3, S1
cmovl S1, P3
cmovle P3, P1
cmp P0, P2
mov P1, P3
cmovle S0, P2
cmovle P2, P0
cmovle P0, S0
cmp P0, P3
cmovge P1, P0
cmovle P3, P0
cmp P2, S1
mov S2, P2
