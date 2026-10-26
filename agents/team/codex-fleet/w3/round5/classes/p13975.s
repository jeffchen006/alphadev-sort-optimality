# n=5 model=out iset=I1 prefix14_class=13975
cmp P3, P0
cmovg S1, P0
mov S0, P2
cmovg P0, P3
cmovg P3, S1
cmp P1, S0
cmovg S0, P1
cmovge P1, P2
cmp P0, S0
cmovle P2, P0
cmovge P2, S0
cmovl P0, S0
mov S2, P1
cmovle S0, P2
