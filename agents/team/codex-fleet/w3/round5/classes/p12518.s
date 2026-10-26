# n=5 model=out iset=I1 prefix14_class=12518
mov S1, P2
mov S0, P1
cmp P3, P1
cmovl P1, P3
cmovle P3, S0
cmp P2, P0
cmovge P2, P0
cmovg P0, S1
cmp P2, P1
cmovg S2, P1
cmovge P1, P2
cmovg P2, S2
cmp P0, P3
mov P2, P0
