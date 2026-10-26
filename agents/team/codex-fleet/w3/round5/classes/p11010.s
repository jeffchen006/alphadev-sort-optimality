# n=5 model=out iset=I1 prefix14_class=11010
cmp P2, P1
cmovg S2, P1
cmovge P1, P2
mov S0, P0
cmovg P2, S2
cmp P3, P0
cmovle S0, P3
cmovle P3, P0
mov S1, P3
cmp P3, P1
cmovle P3, P1
cmovle P1, S1
cmp P2, S0
cmovle S1, S0
