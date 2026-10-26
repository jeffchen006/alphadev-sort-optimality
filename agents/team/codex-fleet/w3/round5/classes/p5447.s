# n=5 model=out iset=I1 prefix14_class=5447
cmp P0, P3
cmovg S2, P3
cmovle S2, P0
cmovle P0, P3
cmp P1, P2
mov P3, S2
cmovge S1, P2
cmovge P2, P1
cmovge P1, S1
cmp P1, P3
cmovle P3, P1
cmovl P1, S2
mov S0, P2
cmovg S2, P1
