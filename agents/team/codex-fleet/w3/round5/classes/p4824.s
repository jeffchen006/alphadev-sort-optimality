# n=5 model=out iset=I1 prefix14_class=4824
cmp P1, P2
mov S0, P2
cmovle P2, P1
cmovg S0, P1
cmp P0, P3
mov S1, P0
mov S2, P2
cmovge P0, P3
cmovge P3, S1
cmp P0, S2
cmovg P2, P0
cmovle S2, P0
cmp P3, S0
mov P0, P2
