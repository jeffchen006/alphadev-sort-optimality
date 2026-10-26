# n=5 model=out iset=I1 prefix14_class=2744
mov S0, P0
mov S1, P1
cmp P1, P2
cmovg S1, P2
cmovge P2, P1
cmp P3, P0
cmovl S0, P3
cmovle P3, P0
cmp P3, P2
cmovle S2, P3
cmovle P3, P2
cmovle P2, S2
mov P0, S0
mov P3, P2
