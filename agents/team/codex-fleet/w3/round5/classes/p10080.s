# n=5 model=out iset=I1 prefix14_class=10080
mov S0, P3
cmp P2, S0
cmovle P3, P2
cmovle P2, S0
cmovg S0, P2
cmp P0, P1
cmovge S1, P1
cmovg P1, P0
cmovge P0, S1
cmp P2, P1
cmovle P2, P1
cmovg S0, P1
cmp P3, P0
cmovle P1, P3
