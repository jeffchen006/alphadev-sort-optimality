# n=5 model=out iset=I1 prefix14_class=7518
cmp P2, P0
mov S0, P0
cmovle P0, P2
cmovg S0, P2
cmp P3, P1
cmovge S2, P1
cmovge P1, P3
cmovge P3, S2
cmp P0, P3
mov P2, P0
cmovl P0, P3
cmovle P3, P2
mov P3, P1
mov S1, P0
