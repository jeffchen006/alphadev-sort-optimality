# n=5 model=out iset=I1 prefix14_class=11889
cmp P3, P0
mov S1, P1
mov S0, P0
cmovg S0, P3
cmovg P3, P0
cmp P2, P1
cmovle P1, P2
cmovle P2, S1
cmp P2, S0
cmovge P0, P2
cmovg P2, S0
cmovg S0, P0
cmp P1, P3
cmovle S0, P1
