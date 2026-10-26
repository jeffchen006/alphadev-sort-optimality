# n=5 model=out iset=I1 prefix14_class=9742
cmp P2, P3
cmovg S0, P3
mov S1, P0
cmovge P3, P2
cmovle S0, P2
cmp P1, P0
cmovle P0, P1
cmovle P1, S1
cmp P1, P3
cmovge S1, P1
cmovg P1, P3
cmovg P3, S1
mov P3, P1
mov S2, P0
